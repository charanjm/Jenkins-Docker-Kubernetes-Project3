pipeline {
    agent any
    tools {
        maven 'Maven'
    }

    environment {
        PROJECT_ID = 'active-alchemy-459306-v2'
        CLUSTER_NAME = 'kube-cluster'
        LOCATION = 'us-central1-c'
        CREDENTIALS_ID = 'kubernetes'
    }

    stages {
        stage('Scm Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -U'
            }
        }

        stage('Test') {
            steps {
                echo "Running Tests..."
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    myimage = docker.build("chaja6r/devops:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        myimage.push("${env.BUILD_ID}")
                        myimage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                script {
                    def files = ['serviceLB.yaml', 'deployment.yaml']
                    files.each { file ->
                        sh "sed -i 's/tagversion/${env.BUILD_ID}/g' ${file}"
                        step([$class: 'KubernetesEngineBuilder', 
                              projectId: env.PROJECT_ID, 
                              clusterName: env.CLUSTER_NAME, 
                              location: env.LOCATION, 
                              manifestPattern: file, 
                              credentialsId: env.CREDENTIALS_ID, 
                              verifyDeployments: true])
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Docker images..."
            sh "docker rmi charan/devops:${env.BUILD_ID} || true"
        }
    }
}
