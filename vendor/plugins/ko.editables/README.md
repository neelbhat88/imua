﻿ko.editables
============
This is plugin for KnockoutJS which allows to accept or rollback changes on observables or view models.
It is extremely easy to use solution suitable in most use cases.

You could find examples of usage on http://romanych.github.com/ko.editables/

editable extender
-----------------

Adds following methods to any writeable observable:

* `beginEdit()`
* `commit()`
* `rollback() `
* `oldValue() `

Also it adds `hasChanges` observable property.
`hasChanges` returns boolean value indicating wether the actual value of observable is different to initial value or not.
Under initial value we understand value of ubservable when `beginEdit()` was called.

Example: 

    var name = ko.observable().extend({editable: true});
    var nameLength = ko.dependentObservable(function() {
        return name() ? name().length : 0;
    });

    name('user');       // name set to 'user'
    name.beginEdit();   // begin transaciton
    name('me');         // name set to 'me', nameLength was recalculated
	name.oldValue(); 	// gives us 'user'
    nameLength();       // gives us 2
    name.hasChanges();  // gives us `true`
    name.commit();      // transaction commited; values are unchanged since last edit; we could start another one
    name.hasChanges();  // gives us `false`
    name.rollback();    // nothing happens since transation is commited
    name.hasChanges();  // gives us `false`
    name.beginEdit();   // begin another transaction
    name('someone');    // name set to 'someone', nameLength was recalculated
    name.rollback();    // rollback transaction; name set to initial value 'me', nameLength recalculated
    name();             // gives us 'me'

*Note*: it is safe to extend same observable multiple times

Checkout `basic-sample.html` for this example.

ko.editable plugin
------------------

Extends any object with same methods and properties as editable extender.
Basically it iterates over all poperties of passed object and extends all writeable observables with editable extender.
Also it goes into deep when scaning for observables. So you could use pretty compex viewModels and activate editable with single call

Example:

    var user = {
        FirstName: ko.observable('Some'),
        LastName: ko.observable('Person'),
        Address: {
            Country: ko.observable('USA'),
            City: ko.observable('Washington')
        }
    };
    ko.editable(user);

    user.beginEdit();
    user.FirstName('MyName');
    user.hasChanges();          // returns `true`
    user.commit();
    user.hasChanges();          // returns `false`
    user.Address.Country('Ukraine');
    user.hasChanges();          // returns `true`
    user.rollback();
    user.Address.Country();     // returns 'USA'

*Tip*: if you are using view models based on classes the best practice is to call
`ko.editable(this)` when all data properties are defined

Checkout `advanced-sample.html` for this example.

Using scopes with extender
--------------------------

From time to time model is pretty complex and part of it declared in different places. Just small example, you have view model with 2 sets of fields:
* Personal Information
* Settings

	var ViewModel = function() {
		var self = this;
		self.FirstName = ko.observable();
		self.LaststName = ko.observable();
		
		self.ReceiveEmails = ko.observable(false);
		self.ShowMyEmail = ko.observable(false);
	};

You want to add check have user changed something in Personal information or in Setting sections. It is very easy to do with scoping:

	var ViewModel = function() {
		var self = this;
		self.FirstName = ko.observable().extend({editable: { scope: 'Personal' }});
		self.LastName = ko.observable().extend({editable: { scope: 'Personal' }});
		self.ChangedPersonalInformation = ko.computed(function() {
			return ko.editable.hasChanges('Personal');
		});
		
		self.ReceiveEmails = ko.observable(false).extend({editable: { scope: 'Settings' }});
		self.ShowMyEmail = ko.observable(false).extend({editable: { scope: 'Settings' }});
		self.ChangedSettings = ko.computed(function() {
			return ko.editable.hasChanges('Settings');
		});
	};

The usage is pretty simple:

	var viewModel = new ViewModel();
	viewModel.FirstName('Josh');
	viewModel.LastName('Pill');
	
	ko.editable.beginEdit('Personal'); // Important! You begin to edit scopes, not the view model or observable.
	ko.editable.beginEdit('Team');
	
	viewModel.FirstName('Me');
	viewModel.ChangedPersonalInformation(); // `true`
	viewModel.ChangedSettings();            // `false`

	viewModel.ShowMyEmail(true); 
	viewModel.ChangedSettings();            // `true`
	
	ko.editable.commit('Personal');
	ko.editable.rollback('Settings');
	
	viewModel.FirstName();                  // `Me`
	viewModel.ShowMyEmail();                // `false`
	viewModel.ChangedPersonalInformation(); // `false`
	viewModel.ChangedSettings();            // `false`
	
Checkout `scoping-sample.html` for this example.