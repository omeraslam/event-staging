var SurveyQuestionForm = React.createClass({
    getInitialState: function() {
        return {surveyObj: this.props.surveyObj}
    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.surveyObj;
        obj[name] = e.target.value;
        this.setState({surveyObj: obj});
    },

    render: function() {
        return (


             <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form className="edit_ticket">
                    <div className="input-group">
                      <label>Question Text</label>
                      <input name="price" type="text" value={this.state.surveyObj.question_text} onChange={this.handleChange} />
                    </div>

                    <div className="input-group" id="datepairExample">
                      <label>Response Required</label>
                      <input name="response_required" type="text" className="date" value={this.state.surveyObj.response_required} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Description</label>
                      <input name="description" type="text" value={this.state.surveyObj.description} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Field Type</label>
                      <input name="field_type" type="text" value={this.state.surveyObj.field_type} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Buyer Field</label>
                      <input name="field_type" type="text" value={this.state.surveyObj.field_type} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Ticket Type</label>
                      <input name="ticket_id" type="text" value={this.state.surveyObj.ticket_id} onChange={this.handleChange} />
                    </div>
                       <div className="input-group">
                      <label>Event Id</label>
                      <input name="event_id" type="text" value={this.state.surveyObj.event_id} onChange={this.handleChange} />
                    </div>

                       <div className="input-group">
                      <label>Published</label>
                      <input name="is_active" type="text" value={this.state.surveyObj.is_active} onChange={this.handleChange} />
                    </div>

                       <div className="input-group">
                      <label>Free Text Active</label>
                      <input name="free_text_active" type="text" value={this.state.surveyObj.free_text_active} onChange={this.handleChange} />
                    </div>

                       <div className="input-group">
                      <label>Free Text</label>
                      <input name="free_text" type="text" value={this.state.surveyObj.free_text} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>


    





        )
    }
})