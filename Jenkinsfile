pipeline {
    agent {
        label "npm-node-agent"
    }

    stages {

        stage('Git SCM') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', url: 'https://github.com/IsraelDavidDahan85/react-test-ts.git'
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    script {
                        sh 'echo successfully build'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    sh 'npm install && npm run test run'
                
                }
            }
        }
        stage('Build') {
            agent {
                label "docker"
            }
            steps {
                script {
                    sh '''
                    docker build -t react-test-ts .
                    withDockerRegistry([credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/']) {
                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                        sh 'docker tag react-test-ts $DOCKER_USER/react-test-ts'
                        sh 'docker push $DOCKER_USER/react-test-ts'
                    }
                    '''
                }
            }
        }


    }
}
