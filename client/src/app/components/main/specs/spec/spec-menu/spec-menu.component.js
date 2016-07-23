module.component('specMenu', {
    require: {
        parent: '^^spec'
    },
    bindings: {
        spec: '<'
    },
    templateUrl: 'app/components/main/specs/spec/spec-menu/spec-menu.template.html',
    controller: function(
        $specs, 
        $mdDialog,
        BreadcrumbsService) {
            
       var self = this;
       
       self.openSpecMenu = function($mdOpenMenu, ev) {
            $mdOpenMenu(ev);
        };
        
        self.addChildren = function(ev) {
            $specs.addManyParent = self.spec;
            $mdDialog.show({
              template: '<add-specs-modal layout="column"></add-specs-modal>',
              targetEvent: ev,
              clickOutsideToClose: false
            });
        };
        
        self.setBreadCrumbs = function() {
            BreadcrumbsService.setBreadcrumbs(self.spec.id);
        };
        
        self.bookmark = function(){
            self.spec.bookmarked = !self.spec.bookmarked;
            $specs.bookmark(self.spec);
        };
        
        self.addTicket = function(ev){
            var confirm = $mdDialog.prompt()
                .title('associate link')
                .placeholder('#00000000')
                .clickOutsideToClose('true')
                .ariaLabel('associate link')
                .targetEvent(ev)
                .ok('save')
                .cancel('cancel');
            $mdDialog.show(confirm).then(function(result) {
                $specs.addTicket(self.spec, result).then(function(ticket){
                    self.parent.ticket.push(ticket);
                });
            }, function() {
            });
        };
        
        self.delete = function(ev){
            var confirm = $mdDialog.confirm()
                .title('Are you sure you want to delete this spec?')
                .textContent('This will also delete all children and tags')
                .ariaLabel('delete spec confirmation')
                .clickOutsideToClose('true')
                .targetEvent(ev)
                .ok('yes')
                .cancel('cancel');
            $mdDialog.show(confirm).then(function() {
                $specs.delete(self.spec)
            }, function() {
            });
        };
    }
});