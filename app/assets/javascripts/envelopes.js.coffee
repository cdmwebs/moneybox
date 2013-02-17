$ ->

  $('#envelope-distribution select#from').change ->
    recalculate()
  $('#envelope-distribution input.to').keyup ->
    recalculate()

  recalculate()


recalculate = ->
  # from - sum(to)
  income_ttl = $('#envelope-distribution select#from option:selected').data('balance')
  $('#envelope-distribution input.to').each ->
    income_ttl -= $(this).val()
    origin = parseFloat($(this).closest('label').find('span').data('origin') || 0)
    entered = parseFloat($(this).val() || 0)
    pending_balance = origin + entered
    badge_class = (if pending_balance < 0 then 'badge badge-important' else if pending_balance > 0 then 'badge badge-success')
    $(this).closest('label').find('span').html("$#{pending_balance.toFixed(2)}")
    $(this).closest('label').find('span').attr('class', badge_class)
  $('#remaining .value').html( income_ttl.toFixed(2) )
  badge_class = (if income_ttl <= 0 then 'badge badge-important' else 'badge badge-success')
  $('#remaining').attr('class', badge_class )