module.
  component('filter', {
    templateUrl: 'app/components/main/sidebar/filter/filter.template.html',
    controller: function (
      $filter,
      $projects, 
      $specs, 
      $tagtypes,
      $user,
      $state,
      BreadcrumbsService) {
        
      var self = this;
      
      self.formData = {};
      self.selected = [];
      self.ticketed = false;
      self.commented = false;
      self.formData.tag_types = [];
      
      self.$onInit = function() {
        
        $projects.getProjects().then( function(response) {
            self.projects = response;
            self.formData.project = $projects.project();
        });
        
        $projects.addCallback( function(){
            self.projects = $projects.projects;
            self.formData.project = $projects.project();
        });
        
        $projects.addCurrentProjectCallback( function(){
            self.formData.project = $projects.project();
        });
        
        $tagtypes.getTagTypes().then( function(response){
            self.tag_type_groups = response.byGroup;
        });
        
        $tagtypes.addCallback( function(){
            self.tag_type_groups = $tagtypes.tagTypes.byGroup;
        });
        
      }; 
      
      
      self.toggle = function (item) {
        var idx = self.selected.indexOf(item);
        if (idx > -1) {
          self.selected.splice(idx, 1);
          self.formData.tag_types[item] = false;
        }
        else {
          self.selected.push(item);
          self.formData.tag_types[item] = true;
        }
        $state.go('.', {
          tag_type: self.selected, 
        });
        self.submit();
      };
      
      self.toggleTicketed = function(checkbox) {
        if(!checkbox){
          self.formData.ticketed = !self.formData.ticketed;
        }
        self.ticketed = !self.ticketed;
        $state.go('.', {
          ticketed: self.ticketed,
        });
        self.submit();
      };
      
      self.toggleCommented = function(checkbox) {
        if(!checkbox){
          self.formData.commented = !self.formData.commented;
        }
        self.commented = !self.commented;
        $state.go('.', {
          commented: self.commented
        });
        self.submit();
      };
      
      self.changeProject = function() {
        var project = self.formData.project;
        $projects.setCurrentProject(project);
        BreadcrumbsService.clearBreadcrumbs();
        self.submit();
      };
        
      self.submit = function() {
        
        var params = {
          project_id: self.formData.project.id,
          "tag_types[]": self.selected,
          ticketed: self.ticketed,
          commented: self.commented
        };
        
        $specs.setSpecList(params);
        
        
      };
      
    }
    
  });