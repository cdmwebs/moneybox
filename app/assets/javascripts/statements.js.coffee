$ ->
  $('a.statement-transaction-toggle').on 'ajax:success', (evt, data, status, xhr) ->
    $(this).closest('tr').replaceWith(xhr.responseText)