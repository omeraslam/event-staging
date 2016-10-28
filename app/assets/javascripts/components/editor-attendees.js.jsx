var EditorAttendees = React.createClass({
   render: function() {
        return (


            <div className="editor-tool editor-panel-top-nav" id="editor-tool-attendees" >
                <AttendeeList attendees_list={this.props.attendees_list} headers={this.props.headers} />
            </div>

        )
   } 
});