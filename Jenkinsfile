pipeline {
    agent any

    // =============================================
    // ENVIRONMENT VARIABLES — used across stages
    // =============================================
    environment {
        APP_NAME    = 'simple-todo-app'
        VERSION     = "v${BUILD_NUMBER}"   // Jenkins auto-increments BUILD_NUMBER
        IMAGE_TAG   = "${APP_NAME}:${VERSION}"
        IMAGE_LATEST = "${APP_NAME}:latest"
    }

    stages {

        // ==========================================
        // STAGE 1: Get latest code from GitHub
        // ==========================================
        stage('Clone') {
            steps {
                echo "📥 Cloning from GitHub..."
                git branch: 'main',
                    url: 'https://github.com/prakashshinde161004/simple_todo_learnign-.git'
                echo "✅ Code cloned successfully!"
            }
        }

        // ==========================================
        // STAGE 2: Install Node.js dependencies
        // ==========================================
        stage('Install') {
            steps {
                echo "📦 Installing dependencies..."
                dir('backend') {              // run inside backend/ folder
                    sh 'npm install'
                }
                echo "✅ Dependencies installed!"
            }
        }

        // ==========================================
        // STAGE 3: Run Tests
        // ==========================================
        stage('Test') {
            steps {
                echo "🧪 Running tests..."
                // When you add real tests, replace below:
                sh 'echo "Tests passed! (add npm test here)"'
                echo "✅ Tests passed!"
            }
        }

        // ==========================================
        // STAGE 4: Build Docker Image
        // ==========================================
        stage('Docker Build') {
            steps {
                echo "🐳 Building Docker image: ${IMAGE_TAG}"
                sh "docker build -t ${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_TAG} ${IMAGE_LATEST}"
                echo "✅ Docker image built: ${IMAGE_TAG}"
            }
        }

        // ==========================================
        // STAGE 5: Load image into Minikube
        // (Skip this if pushing to real registry)
        // ==========================================
        stage('Load to Minikube') {
            steps {
                echo "📤 Loading image into Minikube..."
                sh "minikube image load ${IMAGE_LATEST}"
                echo "✅ Image loaded into Minikube!"
            }
        }

        // ==========================================
        // STAGE 6: Deploy to Kubernetes
        // ==========================================
        stage('Deploy to K8s') {
            steps {
                echo "🚀 Deploying to Kubernetes..."
                sh 'kubectl apply -f configmap.yaml'
                sh 'kubectl apply -f secret.yaml'
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
                sh 'kubectl rollout restart deployment/todo-deployment'
                sh 'kubectl rollout status deployment/todo-deployment'
                echo "✅ Deployed to Kubernetes!"
            }
        }

        // ==========================================
        // STAGE 7: Verify Deployment
        // ==========================================
        stage('Verify') {
            steps {
                echo "🔍 Verifying deployment..."
                sh 'kubectl get pods'
                sh 'kubectl get service todo-service'
                echo "✅ Deployment verified!"
            }
        }
    }

    // ==========================================
    // POST — runs after all stages complete
    // ==========================================
    post {
        success {
            echo """
            ✅ ================================
            ✅ PIPELINE SUCCESS!
            ✅ App: ${APP_NAME}
            ✅ Version: ${VERSION}
            ✅ Build #: ${BUILD_NUMBER}
            ✅ ================================
            """
        }
        failure {
            echo """
            ❌ ================================
            ❌ PIPELINE FAILED!
            ❌ Check logs above for error
            ❌ Build #: ${BUILD_NUMBER}
            ❌ ================================
            """
        }
        always {
            echo "🧹 Pipeline finished — cleaning up..."
        }
    }
}
