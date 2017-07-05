<strong>Component testing topics: </strong>
<select id="component-testing-topics">
  <option value="basics">Basics</option>
  <option value="page-objects">Page Objects</option>
  <!--
  <option value="appendices">Appendices</option>
  -->
</select>
<script>
  $('#component-testing-topics').change(function() {
    var href = $(this).val();
    $(location).attr('href', href);
  });
  $('#component-testing-topics').val('{{include.selectedOption}}')
</script>
