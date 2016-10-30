var AttendeeList = React.createClass({
    getInitialState: function() {
        return { attendees_list: this.props.attendees_list, headers: this.props.headers}
    },
    getDefaultProps: function() {
        return { attendees_list: [], headers: []}
    },

    componentDidMount: function() {

       
    },

    render: function() {
        //if buyers do not exist, empty state
        if(this.props.attendees_list.items.length > 0) {
            AttendeeContent = <TableElement items={this.props.attendees_list} table_headers={this.props.headers} />;
        } else {
            AttendeeContent = <EmptyState message="No attendees, just yet."/>
        }

        return (
                <div>
                   {AttendeeContent}
                </div>
        )
   } 
});

