'use strict'
html = """
<div class="row">
  <div class="row">
    <div class="col-md-12">
      <form name="form" class="form" role="form" ng-submit="signup(form)" id="login-nav"
        novalidate>

        <div class="form-group">
          <label class="sr-only" for="name">Name</label>
          <input name="name" type="text" class="form-control" id="name" ng-model="model.name"
          placeholder="Full name" required>
          <span ng-show="form.name.$error.required && form.name.$dirty">
            Name is required
          </span>
        </div>

        <div class="form-group">
          <label class="sr-only" for="email">Email address</label>
          <input name="email" type="email" class="form-control" id="email" ng-model="model.email"
          placeholder="Email address" required>
          <span ng-show="form.email.$error.required && form.email.$dirty">
            Email is required
          </span>
        </div>

        <div class="form-group">
          <label class="sr-only" for="password">Password</label>
          <input type="password" class="form-control"  ng-model="model.password"
           ng-minlength="5" ng-maxlength="20" name="password"
          id="password" placeholder="Password" required>
          <span ng-show="form.password.$error.required &&
            form.password.$dirty">Password is required</span>
          <span ng-show="!form.password.$error.required &&
            (form.password.$error.minlength ||
            form.password.$error.maxlength) &&
            form.password.$dirty">Password must be between 5 and 20 characters.</span>
        </div>

        <div class="form-group">
          <label class="sr-only" for="confirmpassword">Confirm Password</label>
          <input type="password" class="form-control" name="confirmpassword"
          ng-model="model.confirmpassword"
          id="confirmpassword" placeholder="Confirm Password" required>
          <span ng-show="form.confirmpassword.$error.required &&
            form.confirmpassword.$dirty">Please confirm your
            password.</span>
          <span ng-show="!form.confirmpassword.$error.required &&
            form.confirmpassword.$error.nomatch &&
            form.password.$dirty">Passwords do not match.</span>
        </div>
        <div class="form-group">
          <button type="submit" class="btn btn-success btn-block">Sign up</button>
        </div>
      </form>
    </div>
  </div>
  <div class="divider"></div>
  <div class="row">
    <input class="btn btn-primary btn-block" type="button"
    id="sign-in-facebook" value="Sign Up with Facebook">
    </input>
  </div>
</div>
"""

controller = (root, scope)->
  scope.model = {}
  scope.signup = (form)->
    if form.$invalid
      return
    if form.$valid and (scope.model.password isnt scope.model.confirmpassword)
      form.confirmpassword.$error.nomatch = yes
      return

    delete scope.model.confirmpassword
      
    user = new Parse.User()
    user.set "name", scope.model.name
    user.set "username", scope.model.email
    user.set "password", scope.model.password
    user.set "email", scope.model.email
    user.set "ACL", new Parse.ACL()
    user.signUp null,
      success: (user) ->
        root.user = user
        root.go '/'
      ,
      error: (user, error) ->
        alert("Invalid username or password. Please try again.")


angular.module("dng.parse").directive "register", ->
  template: html
  restrict: "E"
  replace: yes
  scope: true
  link: (scope, elm, attrs, ctrl) ->

  controller: ['$rootScope', '$scope', controller]

