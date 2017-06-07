podTemplate(
  label: 'build',
  containers: [
    containerTemplate(name: 'docker', image: 'docker:1.11.1', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'golang', image: 'golang:1.8.3', command: 'cat', ttyEnabled: true),
  ],
  volumes:[
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ],
) {
  node('build') {
    stage('checkout') {
      checkout scm
    }

    stage('build') {
      container('golang') {
        sh """
          mkdir -p /go/src/github.com/assembyline/ok
          cp -r . /go/src/github.com/assembyline/ok
          cd /go/src/github.com/assembyline/ok
          go build -ldflags -s ok.go
        """

        sh """
          cp /go/src/github.com/assembyline/ok/ok .
        """
      }
    }

    stage('docker build') {
      container('docker') {
          sh """
            docker build -t quay.io/assemblyline/ok .
          """
      }
    }
  }
}
