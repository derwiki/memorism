<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Memorism</title>
        <link type="text/css" href="css/redmond/jquery-ui-1.8.6.custom.css" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="css/memorism.css" />
        <script type="text/javascript" src="js/jquery-1.4.2.min.js">
        </script>
        <script type="text/javascript" src="js/jquery-ui-1.8.6.custom.min.js">
        </script>
        <script src="js/jquery.flip.min.js"></script>
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
                    card[0].innerHTML = memorism.actions.createPanelContent(slot, 1, true);
                });

                memorism.selected_card = null;
				memorism.selected_card_index = null;
            });
        };
		
		memorism.actions.createPanelContent = function(slot, type, inner_only) {
			if (typeof inner_only == "undefined") {
				inner_only = false;
			}
			
			var content = '';
			if(type == 1) {
				if (!inner_only)
					content += '<div class="panel panel1">';
				content += 'Memorism!';				
				if (memorism.debug)
					content += '<br>\n' + slot.id;
				if (!inner_only)
					content += '</div>';
			} else if(type == 2) {
				if (!inner_only)
					content += '<div class="panel panel2">';
				content += slot.definition === undefined ? slot.term : slot.definition;
				if (memorism.debug)
					content += '<br>\n' + slot.id;
				if (!inner_only)					
					content += '</div>';
			} else if(type == 3) {
				if (!inner_only)
					content += '<div class="panel panel3">';
				content += 'Memorism!';
				if (memorism.debug)
					content += '<br>\n' + slot.id;
				if (!inner_only)
					content += '</div>';
			}
			
			return content;
		}
      
	  	memorism.actions.flipCard = function(target, slot, show_face, revert, clear) {
			if (show_face) {
				var face_content = memorism.actions.createPanelContent(slot, 2);
				if (revert) {
					if (clear) {
						clear_content = memorism.actions.createPanelContent(slot, 3);
						target.queue("fQueue", function(next) {
							target.flip({
								direction: 'rl',
								content: face_content
							});	
							next();
						});
						
						target.delay(1500, "fQueue");
						
						target.queue("fQueue", function(next) {
							target.flip({
								direction: 'lr',
								content: clear_content
							});
							
							next();
						});
						
						target.dequeue("fQueue");
					} else {
						back_content = memorism.actions.createPanelContent(slot, 1);
						target.queue("fQueue", function(next) {
							target.flip({
								direction: 'rl',
								content: face_content
							});	
							next();
						})
						.delay(1500, "fQueue")
						.queue("fQueue", function(next) {
							target.flip({
								direction: 'lr',
								content: back_content
							});
							
							next();
						});
						
						target.dequeue("fQueue");
					}
				}
				else {
					target.flip({
						direction: 'rl',
						content: face_content
					});
				}
			} else {
				var card_content = '';
				if (clear) {
					card_content = memorism.actions.createPanelContent(slot, 3);
				} else {
					card_content = memorism.actions.createPanelContent(slot, 1);
				}
				target.flip({
					direction: 'rl',
					content: card_content
				});
			}
			
			if (clear) {
				slot.cleared = true;
			}
		};
	  
        $(document).ready(function(){
            memorism.debug = true;
            memorism.actions.loadTerms();
            
        });

    </script>
    <script type="text/javascript">
        $(function() {
            
            $('#board').click(function(ev) {
                var $target = $(ev.target);
                if (!$target.hasClass('card')) $target = $target.parent();
                
                var card_id = $target[0].id.substring(4);
				var slot = memorism.boardSlots[card_id];
                term_id = slot.id
				
				if (!slot.cleared) {
					if (memorism.selected_card === null) {
						memorism.selected_card = slot;
						memorism.selected_card_index = card_id;
						memorism.actions.flipCard($target, slot, true, false, false);
					}
					else {
						if (memorism.selected_card.id === term_id) {
							memorism.correct += 1;
							alert('correct!');
							memorism.actions.flipCard($target, slot, true, true, true);
							memorism.actions.flipCard($("#card" + memorism.selected_card_index), memorism.selected_card, false, false, true);
						}
						else {
							alert('incorrect!');
							memorism.actions.flipCard($target, slot, true, true, false);
							memorism.actions.flipCard($("#card" + memorism.selected_card_index), memorism.selected_card, false, false, false);
						}
						memorism.selected_card = null;
						memorism.selected_card_index = null;
					}
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
                </div>
            % end
        </div>
    </body>
</html>
