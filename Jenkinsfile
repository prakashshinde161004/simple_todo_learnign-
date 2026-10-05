pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning from GitHub...'
                git branch: 'main',
                    url: 'https://github.com/prakashshinde161004/simple_todo_learnign-.git'
            }
        }

        stage('Install') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo No tests yet!'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying app...'
                sh 'node backend/server.js &'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline SUCCESS!'
        }
        failure {
            echo '❌ Pipeline FAILED!'
        }
    }
}
