JBUNDLER_CLASSPATH = []
JBUNDLER_CLASSPATH << '/Users/pvosges/.m2/repository/com/google/guava/guava/15.0/guava-15.0.jar'
JBUNDLER_CLASSPATH << '/Users/pvosges/.m2/repository/com/unboundid/unboundid-ldapsdk/2.3.5/unboundid-ldapsdk-2.3.5.jar'
JBUNDLER_CLASSPATH.freeze
JBUNDLER_CLASSPATH.each { |c| require c }
