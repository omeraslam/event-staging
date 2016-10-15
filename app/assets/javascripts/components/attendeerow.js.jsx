var AttendeeRow = React.createClass({
    handleDelete: function(e) {
        $.ajax({
            method: 'DELETE',
            url: '/events/' + this.props.attendee.id,
            dataType: 'JSON',
            success: function() {
                this.props.handleDeleteEvent(this.props.attendee)
            }.bind(this)
        });
    },

    render: function() {
            return (


                 <tr> 
                        <td>{this.props.attendee.first_name}</td> 
                        <td>{this.props.attendee.last_name}</td> 
                        <td>{this.props.attendee.email}</td>
                        <td>{this.props.attendee.ticket_type}</td>         
                        <td> {this.props.attendee.created_at}</td>
                    </tr> 

            );
    }
});

