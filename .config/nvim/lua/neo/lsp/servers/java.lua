return {
    require("java").setup({
        root_marker = {
            'settings.gradle',
            'settings.gradle.kts',
            'pom.xml',
            'build.gradle',
            'mvnw',
            'gradlew',
            'build.gradle',
            'build.gradle.kts',
            '.git',
        },
        jdk = {
            auto_install = true,
            version = '21'
        },
        spring_boot_tools = {
            enable = true,
            version = '1.55.1',
        },
        notifications = {
            dap = true,
        },
    }),
}
