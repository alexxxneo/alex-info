В GitLab есть несколько зарезервированных переменных, которые могут быть использованы в ваших CI/CD pipeline'ах для автоматизации процессов. Эти переменные позволяют получить информацию о проекте, пайплайне, коммитах и многом другом.

Вот список самых популярных и часто используемых зарезервированных переменных в GitLab:

### 1. **CI/CD Pipeline и Job переменные**
- **`CI`**  
  Тип: `boolean`  
  Описание: Всегда имеет значение `true`, когда выполняется job в GitLab CI.

- **`CI_COMMIT_REF_NAME`**  
  Тип: `string`  
  Описание: Имя ветки или тега, для которого выполняется job (например, `main`, `feature-branch`, `v1.0.0`).

- **`CI_COMMIT_SHA`**  
  Тип: `string`  
  Описание: SHA-1 хэш текущего коммита.

- **`CI_COMMIT_SHORT_SHA`**  
  Тип: `string`  
  Описание: Короткий хэш текущего коммита (первая часть SHA-1, обычно первые 8 символов).

- **`CI_COMMIT_TITLE`**  
  Тип: `string`  
  Описание: Заголовок коммита, который был создан при выполнении пайплайна.

- **`CI_PIPELINE_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор пайплайна.

- **`CI_PIPELINE_URL`**  
  Тип: `string`  
  Описание: URL страницы с текущим пайплайном.

- **`CI_JOB_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор текущего job.

- **`CI_JOB_URL`**  
  Тип: `string`  
  Описание: URL страницы с текущим job.

- **`CI_JOB_NAME`**  
  Тип: `string`  
  Описание: Имя текущего job.

- **`CI_JOB_STAGE`**  
  Тип: `string`  
  Описание: Имя стадии пайплайна (например, `build`, `test`, `deploy`).

- **`CI_NODE_INDEX`**  
  Тип: `integer`  
  Описание: Индекс параллельной job, начиная с 0.

- **`CI_NODE_TOTAL`**  
  Тип: `integer`  
  Описание: Общее количество параллельных job в данной группе.

### 2. **Переменные проекта**
- **`CI_PROJECT_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор проекта в GitLab.

- **`CI_PROJECT_NAME`**  
  Тип: `string`  
  Описание: Имя проекта.

- **`CI_PROJECT_PATH`**  
  Тип: `string`  
  Описание: Полный путь до проекта, включая группы (например, `group/project-name`).

- **`CI_PROJECT_URL`**  
  Тип: `string`  
  Описание: URL репозитория проекта.

- **`CI_PROJECT_NAMESPACE`**  
  Тип: `string`  
  Описание: Пространство имен проекта, которое включает группу (например, `my-group`).

### 3. **Переменные окружения и runner'ов**
- **`CI_SERVER_URL`**  
  Тип: `string`  
  Описание: URL GitLab сервера.

- **`CI_SERVER_NAME`**  
  Тип: `string`  
  Описание: Имя сервера GitLab (обычно `GitLab`).

- **`CI_SERVER_VERSION`**  
  Тип: `string`  
  Описание: Версия GitLab сервера.

- **`CI_RUNNER_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор runner'а, на котором выполняется job.

- **`CI_RUNNER_DESCRIPTION`**  
  Тип: `string`  
  Описание: Описание runner'а, на котором выполняется job.

- **`CI_RUNNER_TAGS`**  
  Тип: `string`  
  Описание: Теги runner'а, которые можно использовать для фильтрации и выбора runner'ов в pipeline.

### 4. **Переменные пользователя**
- **`GITLAB_USER_ID`**  
  Тип: `integer`  
  Описание: Уникальный идентификатор пользователя, запустившего pipeline.

- **`GITLAB_USER_LOGIN`**  
  Тип: `string`  
  Описание: Логин пользователя, запустившего pipeline.

- **`GITLAB_USER_EMAIL`**  
  Тип: `string`  
  Описание: Email пользователя, запустившего pipeline.

### 5. **Переменные окружения для Docker и Kubernetes**
- **`CI_REGISTRY`**  
  Тип: `string`  
  Описание: URL контейнерного реестра GitLab (например, `registry.gitlab.com`).

- **`CI_REGISTRY_IMAGE`**  
  Тип: `string`  
  Описание: URL образа в реестре контейнеров для текущего проекта.

- **`CI_KUBERNETES_NAMESPACE`**  
  Тип: `string`  
  Описание: Пространство имен Kubernetes, в котором разворачиваются ресурсы.

### 6. **Переменные для деплоя**
- **`CI_ENVIRONMENT_NAME`**  
  Тип: `string`  
  Описание: Имя окружения, в котором выполняется деплой (например, `production`, `staging`).

- **`CI_ENVIRONMENT_URL`**  
  Тип: `string`  
  Описание: URL для доступа к окружению.

- **`CI_DEPLOY_USER`**  
  Тип: `string`  
  Описание: Имя пользователя, который выполняет деплой.

- **`CI_DEPLOY_PASSWORD`**  
  Тип: `string`  
  Описание: Пароль для деплоя.

### 7. **Переменные сборки и артефактов**
- **`CI_COMMIT_REF_PROTECTED`**  
  Тип: `boolean`  
  Описание: Значение `true`, если текущая ветка защищена.

- **`CI_JOB_TOKEN`**  
  Тип: `string`  
  Описание: Токен для аутентификации в других сервисах внутри job'а.

- **`CI_JOB_ARTIFACTS_PATH`**  
  Тип: `string`  
  Описание: Путь к артефактам, которые сохраняются после выполнения job'а.

Эти переменные значительно упрощают настройку CI/CD пайплайнов в GitLab, позволяя автоматизировать множество процессов и гибко настраивать деплой и сборку приложения.