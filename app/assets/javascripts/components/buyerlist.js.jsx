var BuyerList = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, headers: this.props.headers}
    },
    getDefaultProps: function() {
        return { items: [], headers: []}
    },

    componentDidMount: function() {

    },

    render: function() {
        //if buyers do not exist, empty state
        if(this.props.items.items.length > 0) {
            AttendeeContent = <TableElement items={this.props.items} table_headers={this.props.headers} />;
        } else {
            AttendeeContent = <EmptyState message="No orders, just yet."/>
        }

        return (

            <div >
                   {AttendeeContent}
            </div> 
        )
   } 
});

