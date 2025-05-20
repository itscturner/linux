RPMBuild
---

Install RPMBuild Packages:<br>
`sudo yum install -y rpm-build rpmdevtools rpmlint`
<br>

Test Spec Files:<br>
`~/rpmbuild/SPECS/<SPEC-FILE>.spec`
<br>

Check Values of RPM Build Macros:<br>
`rpm --eval "%{buildroot}`
<br>

Build RPM from Spec File:<br>
`rpmbuild -bb ~/rpmbuild/SPECS/<SPEC-FILE>.spec`
