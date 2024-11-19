FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY ./mvn/ .mvn
COPY ./mvnw spring-petclinic/pom.xml ./
RUN ./mvnw dependency:resolve
COPY ./src ./src

#Build Application
RUN ./mvnw package -DskipTests

#Stage2
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Set environment variable for Spring profile (default to 'default')
ENV SPRING_PROFILES_ACTIVE=postgres

# CMD ["java", "-jar", "app.jar"]
CMD ["java", "-jar", "app.jar", "--spring.profiles.active=${SPRING_PROFILES_ACTIVE}"]