require 'spec_helper'

feature 'Pipeline Schedules', :feature, js: true do
  include PipelineSchedulesHelper

  let!(:project) { create(:project) }
  let!(:pipeline_schedule) { create(:ci_pipeline_schedule, :nightly, project: project ) }
  let!(:pipeline) { create(:ci_pipeline, pipeline_schedule: pipeline_schedule) }
  let(:scope) { nil }
  let!(:user) { create(:user) }

  context 'logged in as master' do
    before do
      project.add_master(user)
      gitlab_sign_in(user)
    end

    describe 'GET /projects/pipeline_schedules' do
      before do
        visit_pipelines_schedules
      end

      describe 'The view' do
        it 'displays the required information description' do
          page.within('.pipeline-schedule-table-row') do
            expect(page).to have_content('pipeline schedule')
            expect(find(".next-run-cell time")['data-original-title'])
              .to include(pipeline_schedule.real_next_run.strftime('%b %-d, %Y'))
            expect(page).to have_link('master')
            expect(page).to have_link("##{pipeline.id}")
          end
        end

        it 'creates a new scheduled pipeline' do
          click_link 'New schedule'

          expect(page).to have_content('Schedule a new pipeline')
        end

        it 'changes ownership of the pipeline' do
          click_link 'Take ownership'
          page.within('.pipeline-schedule-table-row') do
            expect(page).not_to have_content('No owner')
            expect(page).to have_link('John Doe')
          end
        end

        it 'edits the pipeline' do
          page.within('.pipeline-schedule-table-row') do
            click_link 'Edit'
          end

          expect(page).to have_content('Edit Pipeline Schedule')
        end

        it 'deletes the pipeline' do
          click_link 'Delete'

          expect(page).not_to have_css(".pipeline-schedule-table-row")
        end
      end

      context 'when ref is nil' do
        before do
          pipeline_schedule.update_attribute(:ref, nil)
          visit_pipelines_schedules
        end

        it 'shows a list of the pipeline schedules with empty ref column' do
          expect(first('.branch-name-cell').text).to eq('')
        end
      end
    end

    describe 'POST /projects/pipeline_schedules/new' do
      before do
        visit_new_pipeline_schedule
      end

      it 'sets defaults for timezone and target branch' do
        expect(page).to have_button('master')
        expect(page).to have_button('UTC')
      end

      it 'it creates a new scheduled pipeline' do
        fill_in_schedule_form
        save_pipeline_schedule

        expect(page).to have_content('my fancy description')
      end

      it 'it prevents an invalid form from being submitted' do
        save_pipeline_schedule

        expect(page).to have_content('This field is required')
      end
    end

    describe 'PATCH /projects/pipelines_schedules/:id/edit' do
      before do
        edit_pipeline_schedule
      end

      it 'it displays existing properties' do
        description = find_field('schedule_description').value
        expect(description).to eq('pipeline schedule')
        expect(page).to have_button('master')
        expect(page).to have_button('UTC')
      end

      it 'edits the scheduled pipeline' do
        fill_in 'schedule_description', with: 'my brand new description'

        save_pipeline_schedule

        expect(page).to have_content('my brand new description')
      end

      context 'when ref is nil' do
        before do
          pipeline_schedule.update_attribute(:ref, nil)
          edit_pipeline_schedule
        end

        it 'shows the pipeline schedule with default ref' do
          page.within('.js-target-branch-dropdown') do
            expect(first('.dropdown-toggle-text').text).to eq('master')
          end
        end
      end
    end

    context 'when user creates a new pipeline schedule with variables' do
      background do
        visit_pipelines_schedules
        click_link 'New schedule'
        fill_in_schedule_form
        all('[name="schedule[variables_attributes][][key]"]')[0].set('AAA')
        all('[name="schedule[variables_attributes][][value]"]')[0].set('AAA123')
        all('[name="schedule[variables_attributes][][key]"]')[1].set('BBB')
        all('[name="schedule[variables_attributes][][value]"]')[1].set('BBB123')
        save_pipeline_schedule
      end

      scenario 'user sees the new variable in edit window' do
        find(".content-list .pipeline-schedule-table-row:nth-child(1) .btn-group a[title='Edit']").click
        page.within('.pipeline-variable-list') do
          expect(find(".pipeline-variable-row:nth-child(1) .pipeline-variable-key-input").value).to eq('AAA')
          expect(find(".pipeline-variable-row:nth-child(1) .pipeline-variable-value-input").value).to eq('AAA123')
          expect(find(".pipeline-variable-row:nth-child(2) .pipeline-variable-key-input").value).to eq('BBB')
          expect(find(".pipeline-variable-row:nth-child(2) .pipeline-variable-value-input").value).to eq('BBB123')
        end
      end
    end

    context 'when user edits a variable of a pipeline schedule' do
      background do
        create(:ci_pipeline_schedule, project: project, owner: user).tap do |pipeline_schedule|
          create(:ci_pipeline_schedule_variable, key: 'AAA', value: 'AAA123', pipeline_schedule: pipeline_schedule)
        end

        visit_pipelines_schedules
        find(".content-list .pipeline-schedule-table-row:nth-child(1) .btn-group a[title='Edit']").click
        all('[name="schedule[variables_attributes][][key]"]')[0].set('foo')
        all('[name="schedule[variables_attributes][][value]"]')[0].set('bar')
        click_button 'Save pipeline schedule'
      end

      scenario 'user sees the updated variable in edit window' do
        find(".content-list .pipeline-schedule-table-row:nth-child(1) .btn-group a[title='Edit']").click
        page.within('.pipeline-variable-list') do
          expect(find(".pipeline-variable-row:nth-child(1) .pipeline-variable-key-input").value).to eq('foo')
          expect(find(".pipeline-variable-row:nth-child(1) .pipeline-variable-value-input").value).to eq('bar')
        end
      end
    end

    context 'when user removes a variable of a pipeline schedule' do
      background do
        create(:ci_pipeline_schedule, project: project, owner: user).tap do |pipeline_schedule|
          create(:ci_pipeline_schedule_variable, key: 'AAA', value: 'AAA123', pipeline_schedule: pipeline_schedule)
        end

        visit_pipelines_schedules
        find(".content-list .pipeline-schedule-table-row:nth-child(1) .btn-group a[title='Edit']").click
        find('.pipeline-variable-list .pipeline-variable-row-remove-button').click
        click_button 'Save pipeline schedule'
      end

      scenario 'user does not see the removed variable in edit window' do
        find(".content-list .pipeline-schedule-table-row:nth-child(1) .btn-group a[title='Edit']").click
        page.within('.pipeline-variable-list') do
          expect(find(".pipeline-variable-row:nth-child(1) .pipeline-variable-key-input").value).to eq('')
          expect(find(".pipeline-variable-row:nth-child(1) .pipeline-variable-value-input").value).to eq('')
        end
      end
    end
  end

  context 'logged in as non-member' do
    before do
      gitlab_sign_in(user)
    end

    describe 'GET /projects/pipeline_schedules' do
      before do
        visit_pipelines_schedules
      end

      describe 'The view' do
        it 'does not show create schedule button' do
          expect(page).not_to have_link('New schedule')
        end
      end
    end
  end

  context 'not logged in' do
    describe 'GET /projects/pipeline_schedules' do
      before do
        visit_pipelines_schedules
      end

      describe 'The view' do
        it 'does not show create schedule button' do
          expect(page).not_to have_link('New schedule')
        end
      end
    end
  end

  def visit_new_pipeline_schedule
    visit new_project_pipeline_schedule_path(project, pipeline_schedule)
  end

  def edit_pipeline_schedule
    visit edit_project_pipeline_schedule_path(project, pipeline_schedule)
  end

  def visit_pipelines_schedules
    visit project_pipeline_schedules_path(project, scope: scope)
  end

  def select_timezone
    find('.js-timezone-dropdown').click
    click_link 'American Samoa'
  end

  def select_target_branch
    find('.js-target-branch-dropdown').click
    click_link 'master'
  end

  def save_pipeline_schedule
    click_button 'Save pipeline schedule'
  end

  def fill_in_schedule_form
    fill_in 'schedule_description', with: 'my fancy description'
    fill_in 'schedule_cron', with: '* 1 2 3 4'

    select_timezone
    select_target_branch
  end
end
