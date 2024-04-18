# Continoues Integration

This document shows the way I setup GitHub Action workflow for this repository. I have some step basic for standard CI pipeline, including lint, unit test ... beside of step to build docker image and scan docker image before push to registry.
In the production environment we should to add some step like SonarQueue to report the code coverage.
