<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Memorism</title>
        <link type="text/css" href="css/redmond/jquery-ui-1.8.6.custom.css" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="css/basic-quickflips.css" />
        <link rel="stylesheet" type="text/css" href="css/memorism.css" />
        <script type="text/javascript" src="js/jquery-1.4.2.min.js">
        </script>
        <script type="text/javascript" src="js/jquery-ui-1.8.6.custom.min.js">
        </script>
        <script type="text/javascript" src="js/jquery.quickflip.source.js">
        </script>
    <script type="application/javascript">
        //shuffles list in-place
        var shuffle = function(list) {
          var i, j, t;
          for (i = 1; i < list.length; i++) {
            j = Math.floor(Math.random()*(1+i));  // choose j in [0..i]
            if (j != i) {
              t = list[i];                        // swap list[i] and list[j]
              list[i] = list[j];
              list[j] = t;
            }
          }
        };

        var memorism = {};
        memorism.constants = {};
        memorism.actions = {};
        memorism.constants.numberOfTerms = 15;
        memorism.first_choice = null;
        memorism.correct = 0;
        
        memorism.actions.loadTerms = function(){
            var page = '/term_tuples/1088936/' + memorism.constants.numberOfTerms;
            memorism.boardSlots = [];
            memorism.definitions = [];
            
            $.getJSON(page, {}, function(data){
                memorism.data = data;
                data.forEach(function(term, index){
                    memorism.boardSlots.push({
                        id: index,
                        term: term[0],
                        cleared: false
                    });
                    memorism.boardSlots.push({
                        id: index,
                        definition: term[1]
                    });
                    memorism.definitions.push({
                        id: index,
                        term: term[0],
                        definition: term[1],
                        cleared: false
                    });
                });
                shuffle(memorism.boardSlots);
                memorism.boardSlots.forEach(function(slot, index){
                    var card = $('#card' + index +' div');
                    card[0].innerHTML = 'Memorism!';
                    if (memorism.debug){card[0].innerHTML += '<br>\n' + slot.id;}
                    card[1].innerHTML = (slot.definition === undefined ? slot.term : slot.definition)
                    if (memorism.debug){card[1].innerHTML += '<br>\n' + slot.id;}
                });

                memorism.selected_card = null;
            });
        };
      
        $(document).ready(function(){
            memorism.debug = true;
            memorism.actions.loadTerms();
            
        });

    </script>
    <script type="text/javascript">
        $(function() {
            
            // for performance first init the quickFlip
            $('.card').quickFlip();

            $('#board').click(function(ev) {
                var $target = $(ev.target);
                if (!$target.hasClass('card')) $target = $target.parent();
                
                var card_id = $target[0].id.substring(4);
                term_id = memorism.boardSlots[card_id].id
                if (memorism.selected_card === null) {
                    memorism.selected_card = term_id;
					$target.quickFlipper();
                } else {
                    if (memorism.selected_card === term_id) {
						$target.quickFlipper();
                        memorism.correct += 1;
                        alert('correct!');
                    } else {
                        $target.quickFlipper({}, null, 2);
                        alert('incorrect!');
                    }
                    memorism.selected_card = null;
                }


            });

        });
    </script>
    </head>
    <body>
        
        <div id="board">
            % for i in range(0, 30):
                <div id="card{{i}}" class="card">
                    <div class="panel panel1"></div>
                    <div class="panel panel2"></div>
                </div>
            % end
        </div>
    </body>
</html>
