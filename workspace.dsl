workspace "Email System" "Микросервисная архитектура системы электронной почты" {

    model {

        user = person "Пользователь" "Пользователь системы электронной почты"

        emailSystem = softwareSystem "Email System" "Система управления пользователями, папками и письмами" {

            webApp = container "Web Application" "Пользовательский интерфейс для работы с системой" "React / HTML / JavaScript"

            userService = container "User Service" "Управляет пользователями: создание и поиск" "REST API (Go / Java / Spring)"

            mailService = container "Mail Service" "Управляет почтовыми папками и письмами" "REST API (Go / Java / Spring)"

            userDb = container "User Database" "Хранит данные пользователей" "PostgreSQL"

            mailDb = container "Mail Database" "Хранит папки и письма" "PostgreSQL"

        }

        user -> webApp "Использует систему" "HTTPS"

        webApp -> userService "Создание и поиск пользователей" "HTTPS/REST"
        webApp -> mailService "Работа с папками и письмами" "HTTPS/REST"

        userService -> userDb "Чтение и запись пользователей" "SQL"
        mailService -> mailDb "Чтение и запись писем и папок" "SQL"
    }

    views {

        systemContext emailSystem "SystemContext" "Контекст системы" {
            include *
            autolayout lr
        }

        container emailSystem "Containers" "Container Diagram" {
            include *
            autolayout lr
        }

        dynamic emailSystem "CreateMessage" "Создание нового письма в папке" {

            user -> webApp "Создает новое письмо"

            webApp -> mailService "POST /folders/{folderId}/messages"

            mailService -> mailDb "Сохраняет письмо в базе"

            mailDb -> mailService "Подтверждает сохранение"

            mailService -> webApp "Возвращает результат"

            webApp -> user "Отображает результат"

            autolayout lr
        }

        theme default
    }
}