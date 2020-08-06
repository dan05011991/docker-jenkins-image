import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.*
import jenkins.model.*
import hudson.security.*

// Copied from https://github.com/zouzias/useful-jenkins-groovy-init-scripts/blob/master/init.groovy (untested)

def instance = Jenkins.getInstance()

def strategy = new hudson.security.ProjectMatrixAuthorizationStrategy()

// NOW TIME TO CONFIGURE GLOBAL SECURITY
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
//  sample LDAP setup
String server = 'ldap://projectshadow'
String rootDN = 'dc=example,dc=org'
String userSearchBase = ''
String userSearch = 'uid={0}'
String groupSearchBase = ''

String groupSearchFilter = 'memberOf'
String groupMembershipFilter = '(| (member={0}) (uniqueMember={0}) (memberUid={1}))'

String managerDN = 'cn=admin,dc=example,dc=org'
String passcode = 'admin'
boolean inhibitInferRootDN = true

boolean disableMailAddressResolver = false
String displayNameAttributeName = ''
String mailAddressAttributeName = ''

//SecurityRealm ldap_realm = new LDAPSecurityRealm(server, rootDN, userSearchBase, userSearch, groupSearchBase, managerDN, passcode, inhibitInferRootDN) 
SecurityRealm ldap_realm = new LDAPSecurityRealm(server, rootDN, userSearchBase, userSearch, groupSearchBase, groupSearchFilter, groupMembershipFilter, managerDN, passcode, inhibitInferRootDN, disableMailAddressResolver, null, null, displayNameAttributeName, mailAddressAttributeName)

instance.setAuthorizationStrategy(strategy)
instance.setSecurityRealm(ldap_realm)

strategy.add(Jenkins.ADMINISTER, "admin")
strategy.add(Jenkins.ADMINISTER, "dan")
strategy.add(Jenkins.ADMINISTER, "bill")
strategy.add(Jenkins.READ, "49ers")
strategy.add(Jenkins.READ, "liverpool")
strategy.add(Jenkins.READ, "manunited")

instance.save()
