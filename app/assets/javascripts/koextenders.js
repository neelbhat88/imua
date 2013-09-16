$(window).ready(function() {
	ko.extenders.positiveNum = function(target, overrideMessage) {
		//add some sub-observables to our observable
		target.hasError = ko.observable();
		target.validationMessage = ko.observable();

		//define a function to do validation
		function validate(newValue) {
			if (newValue == null || newValue === "")
			{
				target.hasError(true);
				return false;
			}
			
			if (isNaN(newValue) || newValue < 0)
			{
				target.hasError(true);
		   		target.validationMessage(overrideMessage + " must be a positive number");
		   		return false;
			}

			target.hasError(false);
			target.validationMessage("");
			return true;
		}

		//initial validation
		validate(target());

		//validate whenever the value changes
		target.subscribe(validate);

		//return the original observable
		return target;
	};

	ko.extenders.required = function(target, overrideMessage) {
		//add some sub-observables to our observable
		target.hasError = ko.observable();
		target.validationMessage = ko.observable();

		//define a function to do validation
		function validate(newValue) {
		   target.hasError(newValue ? false : true);
		   target.validationMessage(newValue ? "" : overrideMessage || "");
		}

		//initial validation
		validate(target());

		//validate whenever the value changes
		target.subscribe(validate);

		//return the original observable
		return target;
	};
});