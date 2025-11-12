# JSTL Fix Instructions

## Problem
`java.lang.NoClassDefFoundError: jakarta/servlet/jsp/jstl/core/ConditionalTagSupport`

## Root Cause
The JSTL implementation classes are not being found at runtime, even though the JAR is in the WAR file.

## Solution

### Option 1: Rebuild the Project (Recommended)
1. Clean and rebuild the project:
   ```bash
   mvn clean install
   ```

2. Ensure the JSTL JAR is in `target/Online-Auction-System-1.0.0/WEB-INF/lib/`

3. Restart the Tomcat server

### Option 2: Manual JAR Verification
1. Check if `jakarta.servlet.jsp.jstl-3.0.0.jar` is in `WEB-INF/lib/`
2. Verify the JAR contains the implementation classes
3. If missing, manually copy the JAR to the lib directory

### Option 3: Alternative JSTL Implementation
If the Glassfish implementation doesn't work, you can try:

1. Remove the current JSTL dependency from pom.xml
2. Add this instead:
   ```xml
   <dependency>
       <groupId>jakarta.servlet.jsp.jstl</groupId>
       <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
       <version>3.0.0</version>
   </dependency>
   <dependency>
       <groupId>org.apache.taglibs</groupId>
       <artifactId>taglibs-standard-spec</artifactId>
       <version>1.2.6</version>
   </dependency>
   <dependency>
       <groupId>org.apache.taglibs</groupId>
       <artifactId>taglibs-standard-impl</artifactId>
       <version>1.2.6</version>
   </dependency>
   ```
   Note: This uses the older Apache Taglibs which may need Jakarta namespace mapping.

### Option 4: Check Tomcat Version
Ensure you're using Tomcat 10.1.x or later which fully supports Jakarta EE 10.

## Verification
After applying the fix, test by accessing a JSP page that uses JSTL tags (like `register.jsp` or `index.jsp`).

## Current Configuration
- JSTL API: `jakarta.servlet.jsp.jstl-api:3.0.0`
- JSTL Implementation: `org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.0`
- Taglib URI: `jakarta.tags.core` (correct for Jakarta EE 10)

