pipeline {
    agent none
    stages {
        stage('Build and Test') {
            parallel {
                stage('Linux Server Run') {
                    agent {
                        label 'master'
                    }
                    environment {
                        PATH = '/home/kirby/bin:/home/kirby/.local/bin:/home/kirby/swift/swift-4.2.1-RELEASE-ubuntu16.04/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
                    }
                    stages {
                        stage('Update Package') {
                            steps {
                                sh 'cd Server; swift package update'
                            }
                        }
                        stage('Build') {
                            steps {
                                sh 'cd Server; swift package clean'
                                sh 'cd Server; swift build'
                            }
                        }
                        stage('Test') {
                            steps {
                                sh 'cd Server; swift test'
                            }
                        }
                    }
                }
                stage('Mac Server Run') {
                    agent {
                        label 'ios-slave'
                    }
                    environment {
                        PATH = "/usr/local/bin:/usr/local/sbin:$PATH"
                    }
                    post {
                        success {
                            junit 'build/reports/junit.xml'
                        }
                    }
                    stages {
                        stage('Update Package') {
                            steps {
                                sh 'cd Server; swift package update'
                            }
                        }
                        stage("Swift Build") {
                            steps {
                                sh 'cd Server; swift build'
                            }
                        }
                        stage('Mac Generate Xcode') {
                            steps {
                                sh 'cd Server; swift package generate-xcodeproj'
                            }
                        }
                        stage('Build and Test') {
                            steps {
                                script {
                                    xcodeproj = sh(
                                        script: 'echo *.xcodeproj',
                                        returnStdout: true
                                    ).trim()
                                }
                                sh """
                                cd Server; \
                                xcodebuild \
                                -project ${ xcodeproj } \
                                -scheme Run \
                                -destination 'platform=macOS' \
                                clean \
                                build \
                                test \
                                | xcpretty -r junit
                                """
                            }
                        }
                    }
                }
            }
        }
    }
}