@Library('github.com/tanl200/jenkins-pipeline-library') _
node {

	checkout scm

	def commit = ''

	stage ('1st') {
		firstExample {
			message = 'Test stage completed, please approved for next step'
		}	
	}


	stage ('Approve') {
	    approve {
	    	message = 'Test stage completed, please approved for next step'
	    }	
	}


    stage ('2nd') {
	    secondExample {}    
    }


    stage ('commit message') {
	    commit = sh(returnStdout: true, script: '''
	    a=\$(git log --format=%s%b -n 1 \$(git rev-parse HEAD))
	    echo $a | cut -d ":" -f1
	    ''')
    }

    stage ('kops') {
    	sh 'echo ${commit}'
	    kops {
	    	action = "${commit}"
	    }    
    }


}
