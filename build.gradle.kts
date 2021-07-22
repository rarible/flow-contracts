import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.5.21"
    application
}

group = "org.rarible"
version = "0.1"

repositories {
    mavenCentral()
    maven { url = uri("https://jitpack.io") }
    flatDir { dir("libs") }
}

dependencies {
    implementation(kotlin("reflect"))
    api("com.github.TrustedDataFramework:java-rlp:1.1.20")
    implementation("org.onflow:flow:0.21")
    implementation("org.onflow:flow-jvm-sdk:0.4.0-SNAPSHOT")
    implementation("com.google.guava:guava:30.1.1-jre")
    implementation("com.google.protobuf:protobuf-java:3.17.3")
    implementation("io.grpc:grpc-api:1.39.0")
    implementation("io.grpc:grpc-context:1.39.0")
    implementation("io.grpc:grpc-core:1.39.0")
    implementation("io.grpc:grpc-netty-shaded:1.39.0")
    implementation("io.grpc:grpc-protobuf:1.39.0")
    implementation("io.grpc:grpc-protobuf-lite:1.39.0")
    implementation("io.grpc:grpc-stub:1.39.0")
    implementation("org.bouncycastle:bcprov-jdk15on:1.69")
    implementation("org.bouncycastle:bcpkix-jdk15on:1.69")
    implementation("com.fasterxml.jackson.core:jackson-annotations:2.12.3")
    implementation("com.fasterxml.jackson.core:jackson-core:2.12.3")
    implementation("com.fasterxml.jackson.core:jackson-databind:2.12.3")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.12.3")
    implementation("org.junit.jupiter:junit-jupiter:5.7.0")
    testImplementation(kotlin("test-junit5"))
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.7.2")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.7.2")
}

tasks.test {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "13"
}

application {
    mainClass.set("MainKt")
}