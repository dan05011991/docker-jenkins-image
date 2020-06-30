/*
 * Disable Jenkins CLI.
 * This init script for Jenkins fixes a zero day vulnerability.
 * http://jenkins-ci.org/content/mitigating-unauthenticated-remote-code-execution-0-day-jenkins-cli
 * https://github.com/jenkinsci-cert/SECURITY-218
 */
import jenkins.*

// Constants
def instance = Jenkins.getInstance()

def gitGlobalConfigName = env['GIT_GLOBAL_CONFIG_NAME']
def gitGlobalConfigEmail = env['GIT_GLOBAL_CONFIG_EMAIL']

println "--> disabling the Jenkins CLI"
CLI.get().setEnabled(false)

// Git Identity
println "--> Configuring Git Identity"
def desc_git_scm = instance.getDescriptor("hudson.plugins.git.GitSCM")
desc_git_scm.setGlobalConfigName(gitGlobalConfigName)
desc_git_scm.setGlobalConfigEmail(gitGlobalConfigEmail)

instance.save()