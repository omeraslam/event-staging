var PrintList = React.createClass({
    getInitialState: function() {
        return { attendees_list: this.props.attendees_list}

    },
    getDefaultProps: function() {
        return { attendees_list: []}
    },

    render: function() {

        return (
            <div className="event-header dashboard-container">

                <div className="event-meta">
                    <p> <strong>Event Name:</strong> </p>
                    <p className="lead">
                        <strong> Date: </strong>
                    </p>
                </div>

                <div className="event-status">
                </div>

            </div>
        )
   }
});