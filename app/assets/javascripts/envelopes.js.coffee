$ ->


  $('#envelope-distribution select#from').change ->
    recalculate()
  $('#envelope-distribution input.to').keyup ->
    recalculate()


recalculate = ->
  # from - sum(to)
  income_ttl = $('#envelope-distribution select#from option:selected').data('balance')
  $('#envelope-distribution input.to').each ->
    income_ttl -= $(this).val()
  $('#remaining .value').html( income_ttl.toFixed(2) )
  badge_class = (if income_ttl <= 0 then 'badge badge-important' else 'badge badge-success')
  $('#remaining').attr('class', badge_class )