FROM openjdk:17-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ./target/SpringAPI-0.0.1.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]