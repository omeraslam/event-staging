var QuestionForm = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug,
            event_id: this.props.event_id,
            ticket_types: this.props.ticket_types

        }
    },

    setItemDate: function(dateText) {
        ticketObj = this.state.current_selection;
        ticketObj["stop_date"] = dateText;
        console.log(ticketObj);
        this.setState({current_selection: ticketObj})

    },


    componentWillReceiveProps: function(nextProps) {
      nextProps.current_selection.stop_date = moment(nextProps.current_selection.stop_date).format('MM/DD/YYYY');
        
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    componentDidMount: function() {
        var that = this;
        //format specific 
        this.state.current_selection.stop_date = moment(this.state.current_selection.stop_date).format('MM/DD/YYYY');
        this.setState({current_selection: this.state.current_selection})
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'MM/DD/YYYY',
          'autoclose': true
        });

   
    },

    handleUpdate: function(e) {


        e.preventDefault();
        var that = this;
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
        var method, uri;
        if (this.state.current_selection.id == null) {
            method = 'POST'
            uri = this.props.event_slug + '/questions'
        } else {
            method = 'PUT'
            uri = '/survey_questions/' + this.state.current_selection.id
        }
        $.ajax({
            method: method,
            url: uri,
            data: {"survey_question" : {
                     "question_text" : this.state.current_selection.question_text, 
                      "response_required" : this.state.current_selection.response_required, 
                      "apply_to_buyer" : this.state.current_selection.apply_to_buyer,
                      "description" : this.state.current_selection.description, 
                      "answer_text" : this.state.current_selection.answer_text, 
                      "field_type" : this.state.current_selection.field_type, 
                      "ticket_id" : this.state.current_selection.ticket_id, 
                      "event_id" : this.state.event_id,
                      "is_active" : this.state.current_selection.is_active,
                      "free_text_active" : this.state.current_selection.free_text_active,
                      "free_text" : this.state.current_selection.free_text
            }},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               // this.props.handleDeleteEvent(this.props.event)
                
              that.props.onAddedNewItem(this.state.current_selection);
              that.props.onUpdateMessage('Survey question has been updated');
               
            }.bind(this)
        });

        

    },

    handleChange: function(e) {
     
        var thun = e.target;
        var name, obj;
        name = e.target.name;
        obj = this.state.current_selection;
        var ticketArray = [];
          var ticket_value_string = '';
        if(name == 'ticket_id') {
          ticketArray = [];
          ticket_value_string = '';
          $('input[name="ticket_id"]').each(function() {
            console.log($(this).val());
            if($(this).is(':checked')) {
              ticketArray.push($(this).val());
            }

              ticket_value_string = ticketArray.toString();
              console.log('ticket string: '+ticket_value_string);

            obj[name] = ticket_value_string;
          });
        } else {
          obj[name] = e.target.value;

        }
        console.log(JSON.stringify(obj));
        this.setState({current_selection: obj});
    },


    render: function() {
        //alert(this.props.event_id)
        return (
                <div>
                <h1>{this.props.current_selection.title}</h1>

                    <form>
                        <div className="input-group">
                            <label>Survey Active</label>
                             <select name="is_active"  value={this.state.current_selection.is_active} onChange={this.handleChange} >
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                              </select>
                        </div>

                        <div className="input-group">
                            <label>Question Text</label>
                            <input name="question_text" type="text" className="input-primary" value={this.state.current_selection.question_text} onChange={this.handleChange}  />
                        </div>


                        <div className="input-group">
                            <label>Description</label>
                            <textarea name="description" type="text" className="input-primary" value={this.state.current_selection.description} onChange={this.handleChange} ></textarea>
                        </div>

                        <div className="input-group">
                            <label>Field Type</label>

                              <select name="field_type"  value={this.state.current_selection.field_type} onChange={this.handleChange} >
                                <option value="1">Text Area</option>
                                <option value="2">Input Type</option>
                                <option value="3">Checkbox</option>
                                <option value="4">Radio Box</option>
                              </select>

                        </div>

                        <div className="input-group">
                        <label>Apply question to:</label>

                        <label><input type="checkbox" name="apply_to_buyer" className="input-primary" value={this.state.current_selection.apply_to_buyer} onChange={this.handleChange} />Buyer</label>
                        {this.state.ticket_types.map(function(item, index){
                           var test = this.state.current_selection.ticket_id.indexOf(item.item.id.toString()) > -1;
                             return !item.item.is_active ? '' : <label key={index} ><input type="checkbox" checked={test}  name="ticket_id" className="input-primary" value={item.item.id} onChange={this.handleChange}  />{item.item.title}</label>
                         }.bind(this))} 
                        </div>


                        <input type="hidden" name="survey_question[event_id]" value={this.state.event_id} />




                        <div className="input-group">
                            <button onClick={this.handleUpdate} className="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>


        )
    }

});





  


         
















       