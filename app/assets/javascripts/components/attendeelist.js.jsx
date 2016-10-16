var AttendeeList = React.createClass({
    getInitialState: function() {
        return { attendees_list: this.props.attendees_list}
    },
    getDefaultProps: function() {
        return { attendees_list: []}
    },

    componentDidMount: function() {
        // call the tablesorter plugin
        var $table = $(".table-attendees").tablesorter({
          // Sort on the second column, in ascending order
          sortList: [[1,0]],
           widgets: [ "filter"],
               widgetOptions : {
            // use the filter_external option OR use bindSearch function (below)
            // to bind external filters.
            filter_external : '.table-search-attendees',
            filter_columnFilters: false,
            filter_saveFilters : true    
        }

        });
        //$.tablesorter.filter.bindSearch( $table, $('.search') );
        //
    },

    render: function() {
        //if buyers do not exist, empty state
        if(this.props.attendees_list.attendees.length > 0) {
            AttendeeContent = <TableElement attendees_list={this.props.attendees_list} />;
        } else {
            AttendeeContent = <EmptyState message="No attendees, just yet."/>
        }

        return (

            <div className="editor-tool editor-panel-top-nav" id="editor-tool-attendees" >
                   {AttendeeContent}
            </div> 
        )
   } 
});

