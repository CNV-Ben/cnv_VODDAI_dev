dai-etl DDL module
===============================

Setup
---------
1. Make sure you have maven2 3.0.3 installed
2. Make sure you have Oracle 11g driver installed at local .m2 repo:
     mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc6 -Dversion=11.2.0.2.0 -Dpackaging=jar -DgeneratePom=true -Dfile=ojdbc6.jar

Assumption
---------
1. You have a local Oracle instance with hostname like "oraclehost"
2. Your Oracle is set up with a "system" Schema with password = canoe
3. You will create "dai_ods" with password "dai_ods" in the default instance
=======


Run
---------
1.  To drop the User and Tables, and re-create everything:
	mvn -Pdb clean -Djdbc.drop=true liquibase:update

2.  To drop the User and Tables, and generate the script from scratch
	mvn -Pdb clean -Djdbc.drop=true liquibase:updateSQL

3.  To generate a delta script from the base to the current version:
	mvn liquibase:updateSQL

4.  To run migration/update from the baseline to the current version:
	mvn liquibase:update

