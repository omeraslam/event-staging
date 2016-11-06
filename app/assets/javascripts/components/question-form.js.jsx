var QuestionForm = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug

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
                      "description" : this.state.current_selection.description, 
                      "answer_text" : this.state.current_selection.answer_text, 
                      "field_type" : this.state.current_selection.field_type, 
                      "ticket_id" : this.state.current_selection.ticket_id, 
                      "event_id" : this.state.current_selection.event_id,
                      "is_active" : this.state.current_selection.is_active,
                      "free_text_active" : this.state.current_selection.free_text_active,
                      "free_text" : this.state.current_selection.free_text
            }},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               // this.props.handleDeleteEvent(this.props.event)
               
            }.bind(this)
        });

        

    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        ticketObj = this.state.current_selection;
        ticketObj[name] = e.target.value;
        this.setState({current_selection: ticketObj});
    },


    render: function() {
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
                            <label>Response required</label>
                            <input name="response_required" type="checkbox" className="input-primary" value={this.state.current_selection.response_required} onChange={this.handleChange}  />
                        </div>

                        <div className="input-group">
                            <label>Description</label>
                            <textarea name="description" type="text" className="input-primary" value={this.state.current_selection.description} onChange={this.handleChange} ></textarea>
                        </div>

                        <div className="input-group">
                            <label>Field Type</label>
                            <input name="field_type" type="number" className="input-primary" value={this.state.current_selection.field_type} onChange={this.handleChange}  />
                        </div>

                        <div className="input-group">
                            <label>Ticket Type</label>
                            <input name="ticket_id" type="number" className="input-primary" value={this.state.current_selection.ticket_id} onChange={this.handleChange}  />
                        </div>

                        <div className="input-group">
                            <label>Free Text Active</label>
                            <input name="free_text_active" type="checkbox" className="input-primary" value={this.state.current_selection.free_text_active} onChange={this.handleChange}  />
                        </div>

                        <div className="input-group">
                            <label>Free Text</label>
                            <textarea name="free_text" className="input-primary" value={this.state.current_selection.free_text} onChange={this.handleChange} ></textarea>
                        </div>



                        <input type="hidden" name="survey_question[event_id]" value={this.state.current_selection.event_id} />




                        <div className="input-group">
                            <button onClick={this.handleUpdate} className="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>


        )
    }

});





  


         
















       