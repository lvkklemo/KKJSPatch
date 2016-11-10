
require('ABTableViewController');
defineClass ('ViewController',{
             handleBtn: function(sender) {
             var ab = ABTableViewController.alloc().init();
             self.navigationController().pushViewController_animated(ab, YES)
             }
             })

//defineClass('ABTableViewController, {
//            dataSource: function() {
//           
//            tableView_numberOfRowsInSection: function(tableView, section) {
//            return 8;
//            },
//            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
//            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
//            if (!cell) {
//            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
//            }
//            cell.textLabel().setText("woaini")
//            return cell
//            },
//            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
//            return 60
//            },
//        
//            })

defineClass ('ABTableViewController',{
             tableView_numberOfRowsInSection: function(tableView, section) {
             return 8;
             },
             tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
                         var cell = tableView.dequeueReusableCellWithIdentifier("cell")
                         if (!cell) {
                         cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
                         }
                         cell.textLabel().setText("wanan")
                         return cell
                         }
             })
