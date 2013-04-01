$ ->
  $('table.statement-transactions').on 'ajax:success', 'a.statement-transaction-toggle', (evt, data, status, xhr) ->
    $(this).closest('tr').replaceWith(xhr.responseText)
    $('h4.totals').load(document.URL+'/totals')