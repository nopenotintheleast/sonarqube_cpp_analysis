CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17
SOURCES = $(wildcard *.cpp)
TARGET = example
ISSUES_REPORT = issues-report.json
SONAR_HOST_URL = http://127.0.0.1:9000
SONAR_PROJECT_KEY = cpp-analysis
SONAR_LOGIN = sqp_8afb1e87f19ec75a236451fbd334af4e5e5c12c1

.PHONY: all sonar fetch-issues clean

all: build sonar fetch-issues

build:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(TARGET)

sonar:
	@echo "Running SonarScanner..."
	@sonar-scanner -Dsonar.projectKey=$(SONAR_PROJECT_KEY) -Dsonar.sources=. -Dsonar.host.url=$(SONAR_HOST_URL) -Dsonar.login=$(SONAR_LOGIN)

fetch-issues:
	@echo "Fetching issues from SonarQube server..."
	@curl -u $(SONAR_LOGIN): "http://127.0.0.1:9000/api/issues/search?componentKeys=$(SONAR_PROJECT_KEY)&ps=500" | jq '.issues[] | {file: .file, message: .message, severity: .severity}'

clean:
	rm -f $(TARGET) $(ISSUES_REPORT)




