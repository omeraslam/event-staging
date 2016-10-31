var EventUrlForm = React.createClass({
    getInitialState: function() {
        return { 
            eventObj: this.props.eventObj,
            updateEvent: this.props.onUpdateEventItem,


        }
    },
    componentWillReceiveProps: function(nextProps) {
      alert('nextprops in url form: '+nextProps);
        // this.setState({
        //     eventObj: nextProps.eventObj,
        //     updateEvent: nextProps.onUpdateEventItem

        // })
    },

    handleUpdate: function(e) {

        e.preventDefault();
        var method, uri;

        var that = this;
      
        method = 'PUT'
        uri = '/events/' + this.state.eventObj.id
        $.ajax({
            method: method,
            url: uri,
            data: {"event": this.state.eventObj},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               alert('handle update on url form:'+JSON.stringify(that.state.eventObj.slug));
               that.state.updateEvent(this.state.eventObj)
               
            }.bind(this)
        });

        

    },

    componentDidMount: function() {

    $(".edit_event").on("ajax:success", function(e, data, status, xhr) {

      }).on("ajax:error", function(e, data, status, xhr) {
        alert('ajax error');

      var alertHTML = '<label id="event_slug-error" class="error" for="event_slug">Custom url name has already been taken. Please choose another</label>';

        $(alertHTML).insertAfter($('#event_slug'));




        // return $("#step-clients form").render_form_errors('client', data.responseJSON);
      });




  $.validator.addMethod("loginRegex", function(value, element) {
        return /^[a-zA-Z0-9-]+$/i.test(value);
    }, "Event must contain only letters, numbers, or dashes.");


      var validator2 = $(".edit-slug").validate({
         rules: {
           "slug": {
             required: true,
             loginRegex: true
           }
           

         },
         messages: {
           "slug": 'Please enter an event name'
         }
       });

    },
    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.eventObj;
        obj[name] = e.target.value;
        this.setState({eventObj: obj});
    },
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form className="edit-slug">
                    <div className="input-group">
                      <label>Your event URL</label>
                      <input name="slug" type="text" value={this.state.eventObj.slug} onChange={this.handleChange} />
                      <small>www.eventcreate.com/{this.state.eventObj.slug}</small>
                    </div>
                    <div className="input-group">
                      <label>Website Availability</label>
                      <select name="published"  value={this.state.eventObj.published} onChange={this.handleChange} >
                                <option value="true">Live</option>
                                <option value="false">Draft</option>
                              </select>
                      <small>You can prevent anyone from accessing your event website by changing the status to "hidden." Once hidden, only you will be able to view the website when logged in.</small> 
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary" onClick={this.handleUpdate} >Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});