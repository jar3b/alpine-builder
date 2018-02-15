# alpine-builder
Docker image with alpine linux to build apk's

Created user `builder` with password `123` because `abuild -r` cannot be executed with root account. 


### Usage:
Here is illustration how to integrate this image with your CI/CD software,
in this case i use GitLab CE + Sonatype Nexus as artifacts storage. Only one
tricky thing is to create variable in GitLab CI with plain http auth to your
Nexus server named `APK_REPO_CRED`.

_.gitlab-ci.yml_
```yaml
image: jar3b/alpine-builder:3.6
stages:
  - release

release:
  stage: release
  variables:
    RV: "1.0.1-r1"
    REPO: "https://nexus.example.org/repository/apk/myrepo"
  script:
    - su -c "abuild checksum" builder
    - su -c "abuild -r" builder
    - cd /home/builder/packages/${CI_PROJECT_NAMESPACE}/x86_64
    - curl -v -u ${APK_REPO_CRED} --upload-file myrepo-$RV.apk $REPO/myrepo-$RV.apk
    - curl -v -u ${APK_REPO_CRED} --upload-file myrepo-lib-$RV.apk $REPO/myrepo-lib-$RV.apk
```

### Available versions:
- 3.5
- 3.6 (latest)