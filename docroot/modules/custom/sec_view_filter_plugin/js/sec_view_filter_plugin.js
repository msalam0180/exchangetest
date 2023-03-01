/**
 * @file
 * Contains the definition of the behaviour secViewsFilterPlugin.
 */
(function ($, Drupal) {


  /**
   * Attaches the JS sec_view_filter_plugin.
   */

  Drupal.behaviors.secViewsFilterPlugin = {
    attach: function (context) {
      // Setup our variables for use;
      var root = $(context).find('form.views-exposed-form');
      var selectOptions = root.find('select#edit-year,select#edit-month');
      var currMonth = (new Date()).getMonth() + 1;
      var currYear = (new Date()).getFullYear();
      // var selMonth;
      var selYear;
      var monthOptions = $('select#edit-month > option');
      // On Document ready check for selected option values;
      selYear = $('select#edit-year').val();
      // selMonth = $('select#edit-month').val();
      if (Number(selYear) === currYear) {
        // Remove future months if selected year matches current year;
        monthOptions.each(function () {
          if (currMonth < Number(this.value)) {
            this.hidden = true;
          }
        });
      }
      else if (selYear === 'All') {
        $('select#edit-month').prop('disabled', true);
        $('#edit-items-per-page').find('option[value="All"]').prop('hidden', true);
      }
      // On change event handler;
      selectOptions.on('change', function (e) {
        $("input[name='aId']", this.form).val($(this).attr('id'));
        $(this).closest('form').submit();
        // if(this.value === "All") window.location.href = window.location.href.split('?')[0];
      });
    }
  };

  /** *
     * Attach an ajax autocompleter for speaker typeahead
     * which calls a REST view via ajax and returns results
     */
  Drupal.behaviors.speaker_autocomplete = {
    attach: function (context, settings) {
      $('.form-item-field-person-target-id input.form-text').autocomplete({
        source: function (req, add) {
          // send off to speaker rest view
          $.getJSON('/speakers.json?search=' + req.term, req, function (data) {
            var results = [];
            $.each(data, function (i, val) {
              var label = val.speaker || val.firstname + ' ' + val.lastname;
              results.push({
                label: label,
                id: val.id
              });
            });
            var preferredSorting = ['Commissioner', 'Chair'];
            results.sort(function (a, b) {
              var compA = $.inArray(a.label.split(' ')[0], preferredSorting);
              var compB = $.inArray(b.label.split(' ')[0], preferredSorting);
              if (compA > compB) { return -1; }
              if (compA < compB) { return 1; }
              return 0;
            });
            add(results);
          });
        },
        select: function (e, ui) {
          // console.info(ui.item.id);
          $('input#edit-speaker', this.form).val(ui.item.id);
          $('input#edit-field-person-target-id', this.form).val(ui.item.label);
          $("input[name='aId']", this.form).val($(this).attr('id'));
          this.form.submit();
        }
      });
    }
  };
})(jQuery, Drupal);
