
const environmentsList = [
  {
    id: 31,
    name: 'production',
    state: 'available',
    external_url: 'https://www.gitlab.com',
    environment_type: null,
    last_deployment: {
      id: 64,
      iid: 5,
      sha: '500aabcb17c97bdcf2d0c410b70cb8556f0362dd',
      ref: {
        name: 'master',
        ref_url: 'http://localhost:3000/root/ci-folders/tree/master',
      },
      tag: false,
      'last?': true,
      user: {
        name: 'Administrator',
        username: 'root',
        id: 1,
        state: 'active',
        avatar_url: 'http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80\u0026d=identicon',
        web_url: 'http://localhost:3000/root',
      },
      commit: {
        id: '500aabcb17c97bdcf2d0c410b70cb8556f0362dd',
        short_id: '500aabcb',
        title: 'Update .gitlab-ci.yml',
        author_name: 'Administrator',
        author_email: 'admin@example.com',
        created_at: '2016-11-07T18:28:13.000+00:00',
        message: 'Update .gitlab-ci.yml',
        author: {
          name: 'Administrator',
          username: 'root',
          id: 1,
          state: 'active',
          avatar_url: 'http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80\u0026d=identicon',
          web_url: 'http://localhost:3000/root',
        },
        commit_path: '/root/ci-folders/tree/500aabcb17c97bdcf2d0c410b70cb8556f0362dd',
      },
      deployable: {
        id: 1278,
        name: 'build',
        build_path: '/root/ci-folders/builds/1278',
        retry_path: '/root/ci-folders/builds/1278/retry',
      },
      manual_actions: [],
    },
    'stop_action?': true,
    environment_path: '/root/ci-folders/environments/31',
    created_at: '2016-11-07T11:11:16.525Z',
    updated_at: '2016-11-07T11:11:16.525Z',
  },
  {
    id: 32,
    name: 'review_app',
    state: 'stopped',
    external_url: 'https://www.gitlab.com',
    environment_type: null,
    last_deployment: {
      id: 64,
      iid: 5,
      sha: '500aabcb17c97bdcf2d0c410b70cb8556f0362dd',
      ref: {
        name: 'master',
        ref_url: 'http://localhost:3000/root/ci-folders/tree/master',
      },
      tag: false,
      'last?': true,
      user: {
        name: 'Administrator',
        username: 'root',
        id: 1,
        state: 'active',
        avatar_url: 'http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80\u0026d=identicon',
        web_url: 'http://localhost:3000/root',
      },
      commit: {
        id: '500aabcb17c97bdcf2d0c410b70cb8556f0362dd',
        short_id: '500aabcb',
        title: 'Update .gitlab-ci.yml',
        author_name: 'Administrator',
        author_email: 'admin@example.com',
        created_at: '2016-11-07T18:28:13.000+00:00',
        message: 'Update .gitlab-ci.yml',
        author: {
          name: 'Administrator',
          username: 'root',
          id: 1,
          state: 'active',
          avatar_url: 'http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80\u0026d=identicon',
          web_url: 'http://localhost:3000/root',
        },
        commit_path: '/root/ci-folders/tree/500aabcb17c97bdcf2d0c410b70cb8556f0362dd',
      },
      deployable: {
        id: 1278,
        name: 'build',
        build_path: '/root/ci-folders/builds/1278',
        retry_path: '/root/ci-folders/builds/1278/retry',
      },
      manual_actions: [],
    },
    'stop_action?': false,
    environment_path: '/root/ci-folders/environments/31',
    created_at: '2016-11-07T11:11:16.525Z',
    updated_at: '2016-11-07T11:11:16.525Z',
  },
  {
    id: 33,
    name: 'test-environment',
    state: 'available',
    environment_type: 'review',
    last_deployment: null,
    'stop_action?': true,
    environment_path: '/root/ci-folders/environments/31',
    created_at: '2016-11-07T11:11:16.525Z',
    updated_at: '2016-11-07T11:11:16.525Z',
  },
  {
    id: 34,
    name: 'test-environment-1',
    state: 'available',
    environment_type: 'review',
    last_deployment: null,
    'stop_action?': true,
    environment_path: '/root/ci-folders/environments/31',
    created_at: '2016-11-07T11:11:16.525Z',
    updated_at: '2016-11-07T11:11:16.525Z',
  },
];

window.environmentsList = environmentsList;

const environment = {
  id: 4,
  name: 'production',
  state: 'available',
  external_url: 'http://production.',
  environment_type: null,
  last_deployment: {},
  'stop_action?': false,
  environment_path: '/root/review-app/environments/4',
  stop_path: '/root/review-app/environments/4/stop',
  created_at: '2016-12-16T11:51:04.690Z',
  updated_at: '2016-12-16T12:04:51.133Z',
};

window.environment = environment;
