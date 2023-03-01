/**
 * @file
 * Contains custom initializer for InsiderDataTable;
 */

(function ($, Drupal) {

//TODO: Refactor since context is not being used. Use it or remove behavior
  Drupal.behaviors.InsiderDataTable = {
    attach: function (context, settings) {
      //swap h1s with theads
      $(".grouped-table h1.grouped").each(function(){
        let h1 = $(this); 
        let thead = h1.next().find("thead");
        thead.append("<tr class='group'><td colspan='" + thead.find("tr.header th").length + "'></td></tr>")
          .find('tr.group td')
          .append("<div class='td-content'>"+h1.text().trim()+"</div>");
        h1.remove();
      })
      $(".grouped-table .view-content tr.header:not(:first)").hide();
      $(".grouped-table .view-content thead tr a").closest("th").addClass("sorting");
      $(".grouped-table .view-content .tablesort--desc").closest("th").addClass("sorting_desc");
      $(".grouped-table .view-content .tablesort--asc").closest("th").addClass("sorting_asc");
      $(".grouped-table .view-content th.sorting").on("click",function() {$(this).find("a").click()})

      var $context = $('.en-datatable table');
      $context.once('dt').each(function (i) {
        var worktable = $(this);
        var num_head_columns = worktable.find('thead tr th').length;
        var rows_to_validate = worktable.find('tbody tr');
        rows_to_validate.each(function (i) {
          // var row_columns = $(this).find('td').length;
          for (i = $(this).find('td').length; i < num_head_columns; i++) {
            $(this).append('<td class="hidden"></td>');
          }
        });
      });

      var dtsettings = {
        isDatatable: $context.length === 1,
        isAdminView: $('.isAdmin table').length === 1,
        noRowGrouping: $('.noRowGrouping table').length === 1,
        isSearchView: $('.content-search table').length === 1,
        defaultOrdering: $('.noOrdering table').length === 1 ? false : true,
        hasPublishDateCol: $context.find('thead th.views-field-changed,th.view-field-sec-event-date,th.view-field-date').length === 1
      };

      if (dtsettings.isDatatable) {
        var tablesorter = $('.tablesorter-header-inner');
        if (tablesorter && tablesorter.is('.tablesorter-header-inner')) {tablesorter.removeClass('tablesorter-header-inner');}
      }

      $.extend($.fn.dataTableExt.oSort, {
        'html-pre': function (a) {
          var aa = a.replace(/<.*?>| /g, '').replace(/[a-zA-Z]*\.*:/, '').trim().toLowerCase();
          return aa;
        }
      });

      var elem = $('.en-datatable table th');
      var naturalIndex = [];
      var naturalNoHTMLIndex = [];
      var defaultSortCol = [];

      elem.each(function () {
      // find all date (non-month/season bar) columns index to natural sort
        if (
          $(this).hasClass('views-field-changed') 
        || $(this).hasClass('views-field-field-sec-event-date') 
        || $(this).hasClass('views-field-field-date')
        ) {
          naturalIndex.push(elem.index(this));
        }
        // find other (non-month/season bar) columns index to natural sort without html
        else if (
          !$(this).hasClass('views-field-changed') 
          || !$(this).hasClass('views-field-field-sec-event-date')
          || $(this).hasClass('views-field-field-form-number')
        ) {
          naturalNoHTMLIndex.push(elem.index(this));
        }
        // default sort column and sort direction
        if ($(this).hasClass('is-active')) {
          defaultSortCol.push(elem.index(this));
          if ($(this).hasClass('views-field-changed') || $(this).hasClass('views-field-field-sec-event-date') ||
          $(this).hasClass('sorting_desc')) {
            defaultSortCol.push('desc');
          }
          else {
            defaultSortCol.push('asc');
          }
        }
        //add default secondary sorting by title
        if ($(this).hasClass("views-field-title") && defaultSortCol.length > 0){
          defaultSortCol.push(elem.index(this));
          if ($(this).hasClass('sorting_desc')) {
            defaultSortCol.push('desc');
          }
          else {
            defaultSortCol.push('asc');
          }
        }
      });

      //look for any data-order attributes in fields and propagate to parent td for datatable ordering
      $('.views-field *[data-order]').each(function() { 
        var column = $(this).parents().filter(".views-field");
        column.attr("data-order", $(this).data("order"));
      });

      $context.DataTable({
        columnDefs: [
          dtsettings.isAdminView || dtsettings.noRowGrouping ? {visible: true, targets: 0} : {visible: false, targets: 0},
          dtsettings.isSearchView ? {orderable: false, targets: [0, 9]} : {},
          dtsettings.hasPublishDateCol ? {type: 'natural', targets: naturalIndex} : {type: 'natural-nohtml', targets: naturalNoHTMLIndex},
          dtsettings.noRowGrouping ? {type: 'natural-nohtml', targets: naturalNoHTMLIndex} : {type: 'html', targets: 0}
        ],
        order: defaultSortCol.length > 0 ? [defaultSortCol[0], defaultSortCol[1]] : [],
        bPaginate: false,
        bFilter: false,
        autoWidth: false,
        bInfo: false,
        searching: false,
        ordering: dtsettings.defaultOrdering,
        retrieve: true,
        bUseRendered: false,
        drawCallback: function (settings) {
          if (dtsettings.isAdminView || dtsettings.noRowGrouping) {return false;}
          var api = this.api();
          var rows = api.rows({page: 'current'}).nodes();
          var last = null;
          var col = $('.en-datatable table').find('thead>tr>th').length;
          api.column(0, {page: 'current'}).data().each(function (group, i) {
            if (last !== group) {
              $(rows).eq(i).before(
                '<tr class="group" scope="col"><td colspan=' + col + '>' + group + '</td></tr>'
              );
              last = group;
            }
          });
        },
        fnInitComplete: function () {
          $('.en-datatable').show();
          this.fnAdjustColumnSizing();
        }
      });

      if (dtsettings.isAdminView) {return false;}

      // Only show grouped col if the Date col is clicked and columns are sortable;
      if (dtsettings.defaultOrdering) {
        var th = $('.en-datatable table th');
        $.each(th, function (index, value) {
          if (index !== 0) {
            $(this).click(function () {
              $('tr.group').hide();
            });
          }
        });
      }
    }
  };
}(jQuery, Drupal));
