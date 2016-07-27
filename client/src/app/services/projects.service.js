var module = angular.module('jessdocs');

module.service('$projects', function(
    $filter,
    $state,
    $api, 
    $q, 
    $user, 
    $location) {
    var self = this;
    
    var callbacks = [];
    
    self.currentProject;
    
    self.getProjects = function() {
        if(self.projects && self.projects.length){
            return $q.when(self.projects);
        }
        return updateProjects();
    };
    
    self.project = function(){
        return self.currentProject;
    };
    
    self.setCurrentProject = function(project){
        self.currentProject = project;  
    };
    
    self.initCurrentProject = function(projectId) {
        if(projectId){
            self.currentProject = $filter('getById')(self.projects, projectId);
        }
        else {
            self.currentProject = self.projects[0];
            $state.go('home', {projectId: self.currentProject.id}, { notify: false });
        }
        
        return self.currentProject;
    };
    
    self.addProject = function(projectName) {
        $api.request({
            url: '/projects',
            method: 'POST',
            data: {
                project: {
                    name: projectName,
                    created_by_id: $user.user().id
                }
            }
        }).then( function(response){
            self.projects.push(response);
            notifyWatchers();
        });
    };
    
    self.editProject = function(project, name) {
        if (project.name !== name){
            $api.request({
                url: '/projects/' + project.id,
                method: 'PUT',
                data: {
                    project: {
                        name: name
                    }
                }
            }).then( function(response){
                updateProjects().then( function(){
                    notifyWatchers();
                });
            });
        }
    };
    
    self.deleteProject = function(project) {
        $api.request({
            url: '/projects/' + project.id,
            method: 'DELETE'
        }).then( function(response){
            updateProjects().then( function(){
                notifyWatchers();
            });
        });
    };
    
    self.addCallback = function(callback) {
        callbacks.push(callback);
    };
    
    function notifyWatchers() {
        callbacks.forEach(function(callback) {
            callback();
        });
    }
    
    
    function updateProjects() {
        var promise = $api.request({
          url: '/projects', 
          method: 'GET'
        }).then(function(response) {
            self.projects = response;
            return response;
        });
        return promise;
    }
});