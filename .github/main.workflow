workflow "Build and publish on push" {
  on = "push"
  resolves = ["Publish"]
}

action "Install dependencies" {
  uses = "docker://node"
  runs = "yarn"
  args = "install --frozen-lockfile"
}

action "Build" {
  needs = "Install dependencies"
  uses = "docker://node"
  runs = "yarn"
  args = "build"
}

action "Test" {
  needs = "Build"
  uses = "docker://node"
  runs = "yarn"
  args = "test --coverage"
}

action "Publish" {
  needs = "Test"
  uses = "actions/npm@master"
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
