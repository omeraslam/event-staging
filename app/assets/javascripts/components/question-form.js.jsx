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
        this.setState({current_selection: ticketObj})

    },


    componentWillReceiveProps: function(nextProps) {
        
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    componentDidMount: function() {
        var that = this;
        //format specific 
        this.setState({current_selection: this.state.current_selection})


        var validator5 = $(".question-form").validate({
        submitHandler: function() { that.handleUpdate() },
        rules: {
          "question_text": {
            required: true
          }
        }, messages : {
          "question_text": 'Please enter a question.'
        }
      });

  

   
    },
    handleValidation: function(e) {

        e.preventDefault();
      },
    handleUpdate: function() {

        var that = this;
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
        var method, uri, save_message;
        if (this.state.current_selection.id == null) {
            method = 'POST'
            uri = this.props.event_slug + '/questions'
            save_message = 'Survey question has been created'
        } else {
            method = 'PUT'
            uri = '/survey_questions/' + this.state.current_selection.id
            save_message = 'Survey question has been updated'
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
            success: function(resp) {

               that.state.current_selection = resp;
               that.props.onAddedNewItem(that.state.current_selection, (method == 'POST'));
               // that.state.current_selection.id = id;
              that.props.onUpdateMessage(save_message);
               
            }.bind(this)
        });

        

    },
    handleDelete: function(e) {
        e.preventDefault();

        var that = this;

        var itemID = this.state.current_selection.id

        $.ajax({
            method: 'POST',
            url: '/remove-question',
            data: {id: this.state.current_selection.id },
            dataType: 'JSON',
            success: function(resp) {
              
              that.props.onUpdateMessage(resp.message);
                if(resp.status == 'success') {
                    that.props.onRemovedNewItem(itemID);
                }
            }.bind(this)
        });


    },

    handleCancel: function(e) {
      e.preventDefault();

         this.props.onResetCurrentSelection();

      //alert('cancel');

    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.current_selection;
        var ticketArray = [];
          var ticket_value_string = '';

        if(name == 'ticket_id') {
          ticketArray = [];
          ticket_value_string = '';
          $('input[name="ticket_id"]').each(function() {
            if($(this).is(':checked')) {
              ticketArray.push($(this).val());
            }

              ticket_value_string = ticketArray.toString();

            obj[name] = ticket_value_string;
          });
        } else {
           if(name == 'apply_to_buyer' || name == 'response_required') {


            obj[name] = (e.target.value == 'false');
            //alert(obj[name]);
          } else {

            obj[name] = e.target.value;
          }



        }

        this.setState({current_selection: obj});
    },


    render: function() {
     
        if(this.state.current_selection.field_type < 3) {

        var divStyle= {display: 'none'}
        } else {

        var divStyle= {display: 'block'}
        }

        var deleteButton = '' 
        if(this.state.current_selection.id != undefined) {
          deleteButton = <a onClick={this.handleDelete} className="link-delete"><i className="fa fa-trash"></i> Delete question</a>
        }
        return (
                <div>
                <div className="page-header">
                  <h1>{this.state.current_selection.question_text}</h1>
                </div>

                    <form className="question-form" onSubmit={this.handleValidation} >
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
                            <label><input type="checkbox"  name="response_required" checked={this.state.current_selection.response_required} className="input-primary" value={this.state.current_selection.response_required} onChange={this.handleChange} />Response required</label>
                        </div>

                        <div className="input-group">
                            <label>Field Type</label>

                              <select name="field_type"  value={this.state.current_selection.field_type} onChange={this.handleChange} >
                                <option value="1">Paragraph Text</option>
                                <option value="2">Single Line Text</option>
                                <option value="3">Checkboxes</option>
                                <option value="4">Multiple Choice (radio buttons)</option>
                              </select>

                        </div>

                        <div className="input-group" style={divStyle}>
                            <label>Choice responses (separated by comma)</label>

                            <textarea name="answer_text" type="text" className="input-primary" value={this.state.current_selection.answer_text} onChange={this.handleChange} ></textarea>

                        </div>

                        <div className="input-group">
                        <label>Apply question to: {this.state.current_selection.apply_to_buyer}</label>

                        <div className="checkbox"><label><input type="checkbox"  name="apply_to_buyer" checked={this.state.current_selection.apply_to_buyer} className="input-primary" value={this.state.current_selection.apply_to_buyer} onChange={this.handleChange} />Ticket Buyer</label></div>
                        {this.state.ticket_types.map(function(item, index){
                           var test = this.state.current_selection.ticket_id == null ? false : this.state.current_selection.ticket_id.indexOf(item.id.toString()) > -1;
                             return !item.is_active ? '' : <div className="checkbox" key={index} ><label><input type="checkbox" checked={test}  name="ticket_id" className="input-primary" value={item.id} onChange={this.handleChange}  />{item.title}</label></div>
                         }.bind(this))} 
                        </div>


                        <input type="hidden" name="survey_question[event_id]" value={this.state.event_id} />




                        <div className="input-group">
                            <button type="submit" className="btn btn-primary">{this.state.current_selection.id == undefined ? 'Save' :  'Update' }</button> <button onClick={this.handleCancel} className="btn btn-primary btn-gray">Cancel</button> {deleteButton}
                        </div>
                    </form>
                </div>


        )
    }

});





  


         
















       