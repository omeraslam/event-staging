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

                    { Object.keys(this.props.attendee).map(function (key) {
                        //alert('key', key);
                        var propitem = this.props.attendee[key]
                        if(key != 'id') {
                            return (

                            <td>{propitem}</td>
                            )

                        }
                        
                    }, this)}
                   
                    </tr> 

            );
    }
});

