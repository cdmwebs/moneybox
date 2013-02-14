$ ->


  $('#envelope-distribution select#from').change ->
    recalculate()
  $('#envelope-distribution input.to').keyup ->
    recalculate()


recalculate = ->
  # from - sum(to)
  console.log 'recalc'