var EditorPanelEmpty = React.createClass({
    getInitialState: function() {
        return { items: this.props.items}
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null}
    },

    componentDidMount: function() {
   
    },

    render: function() {
   

        return (
            <div className="editor-panel empty">
                <i className="icon icon-ticket"> </i>
                <h1>Ticketing</h1>
                <p>Add new ticket. It sure is neat. PS, we've added a sample "General Admssion" ticket for you, to help you get started.</p>
                <p><button className="btn btn-primary">Add ticket</button> </p>
            </div>
        )
   } 
});








 


